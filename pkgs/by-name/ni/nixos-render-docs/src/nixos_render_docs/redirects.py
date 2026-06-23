import json
from dataclasses import dataclass, field
from pathlib import Path

from .manual_structure import XrefTarget


class RedirectsError(Exception):
    def __init__(
        self,
        conflicting_anchors: set[str] = None,
        divergent_redirects: set[str] = None,
        identifiers_missing_current_outpath: set[str] = None,
        identifiers_without_redirects: set[str] = None,
        orphan_identifiers: set[str] = None
    ):
        self.conflicting_anchors = conflicting_anchors or set()
        self.divergent_redirects = divergent_redirects or set()
        self.identifiers_missing_current_outpath = identifiers_missing_current_outpath or set()
        self.identifiers_without_redirects = identifiers_without_redirects or set()
        self.orphan_identifiers = orphan_identifiers or set()

    def __str__(self):
        error_messages = []
        if self.conflicting_anchors:
            error_messages.append(f"""
Identifiers must not be identical to any historical location's anchor of the same output path.
    The following identifiers violate this rule:
    - {"\n    - ".join(self.conflicting_anchors)}

    This can break links or redirects. If you added new content, choose a different identifier.""")
        if self.divergent_redirects:
            error_messages.append(f"""
All historical content locations must correspond to exactly one identifier.
    The following locations violate this rule:
    - {"\n    - ".join(self.divergent_redirects)}

    It leads to inconsistent behavior depending on which redirect is applied.
    Please update doc/redirects.json or nixos/doc/manual/redirects.json!""")
        if self.identifiers_missing_current_outpath:
            error_messages.append(f"""
The first element of an identifier's redirects list must denote its current location.
    The following identifiers violate this rule:
    - {"\n    - ".join(self.identifiers_missing_current_outpath)}

    If you moved content, add its new location as the first element of the redirects mapping.
    Please update doc/redirects.json or nixos/doc/manual/redirects.json!""")
        if self.identifiers_without_redirects:
            error_messages.append(f"""
Identifiers present in the source must have a mapping in the redirects file.
    - {"\n    - ".join(self.identifiers_without_redirects)}""")
        if self.orphan_identifiers:
            error_messages.append(f"""
Keys of the redirects mapping must correspond to some identifier in the source.
    - {"\n    - ".join(self.orphan_identifiers)}""")
        if self.identifiers_without_redirects or self.orphan_identifiers or self.identifiers_missing_current_outpath:
            error_messages.append(f"""
This can happen when an identifier was added, renamed, or removed.

    Added new content?
        $ redirects add-content <identifier> <path>
    often:
        $ redirects add-content <identifier> index.html

    Moved existing content to a different output path?
        $ redirects move-content <identifier> <path>

    Renamed existing identifiers?
        $ redirects rename-identifier <old-identifier> <new-identifier>

    Removed content? Redirect to alternatives or relevant release notes.
        $ redirects remove-and-redirect <identifier> <target-identifier>

    NOTE: Run the right nix-shell to make this command available.
        Nixpkgs:
        $ nix-shell doc
        NixOS:
        $ nix-shell nixos/doc/manual
""")
        error_messages.append("NOTE: If your build passes locally and you see this message in CI, you probably need a rebase.")
        return "\n".join(error_messages)


@dataclass
class Redirects:
    _raw_redirects: dict[str, list[str]]
    _redirects_script: str

    _xref_targets: dict[str, XrefTarget] = field(default_factory=dict)

    def validate(self, initial_xref_targets: dict[str, XrefTarget]):
        """
        Validate redirection mappings against element locations in the output

        - Ensure semantic correctness of the set of redirects with the following rules:
          - Identifiers present in the source must have a mapping in the redirects file
          - Keys of the redirects mapping must correspond to some identifier in the source
          - All historical content locations must correspond to exactly one identifier
          - Identifiers must not be identical to any historical location's anchor of the same output path
          - The first element of an identifier's redirects list must denote its current location.
        """
        xref_targets = {}
        ignored_identifier_patterns = ("opt-", "auto-generated-", "function-library-", "service-opt-", "systemd-service-opt")
        for id, target in initial_xref_targets.items():
            # filter out automatically generated identifiers from module options and library documentation
            if id.startswith(ignored_identifier_patterns):
                continue
            xref_targets[id] = target

        identifiers_without_redirects = xref_targets.keys() - self._raw_redirects.keys()
        orphan_identifiers = self._raw_redirects.keys() - xref_targets.keys()

        client_side_redirects = {}
        server_side_redirects = {}
        conflicting_anchors = set()
        divergent_redirects = set()
        identifiers_missing_current_outpath = set()

        for identifier, locations in self._raw_redirects.items():
            if identifier not in xref_targets:
                continue

            if not locations or locations[0] != f"{xref_targets[identifier].path}#{identifier}":
                identifiers_missing_current_outpath.add(identifier)

            for location in locations[1:]:
                if '#' in location:
                    path, anchor = location.split('#')

                    if anchor in identifiers_without_redirects:
                        identifiers_without_redirects.remove(anchor)

                    if location not in client_side_redirects:
                        client_side_redirects[location] = f"{xref_targets[identifier].path}#{identifier}"
                        for identifier, xref_target in xref_targets.items():
                            if xref_target.path == path and anchor == identifier:
                                conflicting_anchors.add(anchor)
                    else:
                        divergent_redirects.add(location)
                else:
                    if location not in server_side_redirects:
                        server_side_redirects[location] = xref_targets[identifier].path
                    else:
                        divergent_redirects.add(location)

        if any([
            conflicting_anchors,
            divergent_redirects,
            identifiers_missing_current_outpath,
            identifiers_without_redirects,
            orphan_identifiers
        ]):
            raise RedirectsError(
                conflicting_anchors=conflicting_anchors,
                divergent_redirects=divergent_redirects,
                identifiers_missing_current_outpath=identifiers_missing_current_outpath,
                identifiers_without_redirects=identifiers_without_redirects,
                orphan_identifiers=orphan_identifiers
            )

        self._xref_targets = xref_targets

    def get_client_redirects(self, target: str):
        paths_to_target = {src for src, dest in self.get_server_redirects().items() if dest == target}
        client_redirects = {}
        for locations in self._raw_redirects.values():
            for location in locations[1:]:
                if '#' not in location:
                    continue
                path, anchor = location.split('#')
                if path not in [target, *paths_to_target]:
                    continue
                client_redirects[anchor] = locations[0]
        return client_redirects

    def get_server_redirects(self):
        server_redirects = {}
        for identifier, locations in self._raw_redirects.items():
            for location in locations[1:]:
                if '#' not in location and location not in server_redirects:
                    server_redirects[location] = self._xref_targets[identifier].path
        return server_redirects

    def get_redirect_script(self, target: str) -> str:
        client_redirects = self.get_client_redirects(target)
        return self._redirects_script.replace('REDIRECTS_PLACEHOLDER', json.dumps(client_redirects))
