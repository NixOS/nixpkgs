{ pkgs ? import <nixpkgs> { }
, releaseNotesSectionsRoot ? ../sections
, meta ? import ./meta
, debug ? false
}:
let
  inherit (pkgs) lib;
  inherit (lib) concat concatStringsSep mapAttrsToList subtractLists;

  checkSectionContentsOrder = root: sectionId: metaContents:
    let
      sectionDir = "${root}/${sectionId}";
      dirContents = (mapAttrsToList
        (name: _: name)
        (builtins.readDir sectionDir));

      missingMetaContents = subtractLists dirContents metaContents;
      missingDirContents = subtractLists metaContents dirContents;
      orderedDirContents = subtractLists missingMetaContents metaContents;
      orderedSectionContents = concat orderedDirContents missingDirContents;

      dirFeedback = concatStringsSep "" [
        "Files without meta ordering inside "
        "'${sectionId}' directory: "
        "[ \"${concatStringsSep "\"  \"" missingDirContents}\" ]"
      ];
      metaFeedback = concatStringsSep "" [
        "Files not found inside "
        "'${sectionId}' directory: "
        "[ \"${concatStringsSep "\" \"" missingMetaContents}\" ]"
      ];
    in
    lib.warnIf
      (debug && missingDirContents != [ ])
      dirFeedback
      (lib.warnIf
        (debug && missingMetaContents != [ ])
        metaFeedback
        orderedSectionContents);

  sectionContent = root: sectionId: orderedSectionContents:
    let
      sectionDir = "${root}/${sectionId}";
    in
    builtins.concatStringsSep
      "\n"
      (lib.lists.forEach
        orderedSectionContents
        (name: (builtins.readFile "${sectionDir}/${name}")));

  notes-content =
    let
      generateSection = section:
        let
          orderedContents = checkSectionContentsOrder
            releaseNotesSectionsRoot
            section.id
            section.meta;
        in
        [
          "${section.title}\n"
          (sectionContent
            releaseNotesSectionsRoot
            section.id
            orderedContents)
        ];
    in
    builtins.concatStringsSep
      "\n"
      (lib.lists.flatten [
        "${meta.title}\n"
        (lib.lists.forEach
          meta.sections
          (section: (generateSection section)))
      ]);

in
builtins.trace
  "Generating release notes"
  pkgs.runCommand "generate-release-notes" { }
    ''
      mkdir $out
      cat > $out/${meta.rl-filename} << 'EOF'
      ${notes-content}
      EOF
    ''
