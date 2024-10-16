{ lib
, fetchzip
}:

let

  plugin-repos = builtins.fromJSON (builtins.readFile ./repos.json);
  url-hashes = builtins.fromJSON (builtins.readFile ./hashes.json);
  plugin-licenses = import ./licenses.nix lib;

  repo-map = builtins.listToAttrs (builtins.map (repo: {
    name = repo.Name;
    value = repo // {
      version-map = builtins.listToAttrs (builtins.map (version: {
          name = version.Version;
          value = version;
      }) repo.Versions );
      newest-version = lib.last (lib.naturalSort (map (x: x.Version) repo.Versions));
    };
  }) plugin-repos);

in lib.mapAttrs (name: repo:

  let
    repo-version = repo.version-map.${repo.newest-version};
  in fetchzip {
    name = "micro-plugin-${name}-${repo-version.Version}";

    url = repo-version.Url;
    hash = url-hashes.${repo-version.Url};

    stripRoot = false;

    meta = with lib; {
      description = repo.Description;
      longDescription = lib.mdDoc ''
        ${repo.Description}

        To install, symlink this package to `~/.config/micro/plug/${name}`
      '';
      # https://github.com/micro-editor/plugin-channel/issues/86
      license = plugin-licenses.${name} or null;
      maintainers = with maintainers; [ pbsds ];
      platforms = platforms.all;
    } // lib.optionalAttrs (builtins.hasAttr "Website" repo) {
      homepage = repo.Website;
    };
  }

) repo-map
