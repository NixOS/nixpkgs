{ lib }:

let
  # Increase the readability of the output file
  # by arranging each section into the specified order
  knownPrimarySectionNamesDefault = [ "pre" "setup" "files" "post" "environment" "runscript" "startscript" "test" "labels" "help" ];
  knownAppSectionNamesDefault = [ "appfiles" "appinstall" "appenv" "apprun" "applabels" "apphelp" ];

  # TODO: Implement a type for the Apptainer/Singularity definition

  ### Structurize the definition file
  /**!
    * Here is the structured representation of the
    * demo definition file in the Apptainer/Singularity menu:
    * ~~~{.nix}
    * {
    *   # header.Bootstrap is REQUIRED
    *   header = {
    *     Bootstrap = "docker";
    *     From = "ubuntu";
    *   };
    *   setup = ''
    *     touch /file1
    *     touch ''${SINGULARITY_ROOTFS}/file2
    *   '';
    *   # A string instead of a list is also acceptable
    *   files = [
    *     # Element as a list will be concatenated with whitespace as the delimiter
    *     [ "/file1" ]
    *     [ "/file1" "/opt" ]
    *     # If the element is a string instead of a list, it would be composed directly
    *     "some ad-hoc stuff"
    *   ];
    *   # A string or a list instead of a set is also acceptable
    *   # The value part is NOT escaped as shell strings.
    *   # Use `lib.escapeShellArg` to escape special contents
    *   environment = {
    *     __sectionPreScript = "some ad-hoc stuff beforehand";
    *     LISTEN_PORT = "12345"
    *     LC_ALL = "C";
    *     # This will evaluates to
    *     # `export PATH=/nix/store/xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx-hello-0.0.0/bin/hello:/nix/store/xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx-cowsay-0.0.0/bin/cowsay:${PATH:-}`
    *     # when writing as a definition string
    *     PATH = "${lib.makeBinPath [ hello cowsay ]}:\${PATH:-}"
    *     __sectionPostScript = "some ad-hoc stuff afterward";
    *   };
    *   post = ''
    *     # ...
    *   '';
    *   # ...
    *   # A string instead of a set is also acceptable
    *   labels = {
    *     Author = "d@sylabs.io";
    *     Version = "v0.0.1";
    *   };
    *   # ...
    *   # Sections for apps goes here
    *   apps.foo = {
    *     apprun = ''
    *       exec echo "RUNNING FOO"
    *     '';
    *     applabels = {
    *       BOOTSTRAP = "FOO";
    *     };
    *     # ...
    *   };
    * }
    * ~~~
    * The original version can be found here:
    * https://apptainer.org/user-docs/3.1/definition_files.html
    **/
  toSingularityDef =
    { dropUnknownSections ? false
    , knownPrimarySectionNames ? knownPrimarySectionNamesDefault
    , knownAppSectionNames ? knownAppSectionNamesDefault
    , ...
    }:
    let
      orderAs = template: listToOrder: (lib.intersectLists listToOrder template) ++ lib.optionals dropUnknownSections (lib.subtractLists template listToOrder);
      sectionMappingFunction = sectionName: sectionContent:
        map (s: "    ${s}") (
          if (builtins.typeOf sectionContent == "string") then
            (ss: if (ss != [ ]) && (lib.last ss == "\n") then lib.take ((lib.count ss) - 1) ss else ss) (lib.splitString "\n" sectionContent)
          else if (builtins.typeOf sectionContent == "list") then
            map (lineContent: if (builtins.typeOf lineContent == "list") then builtins.concatStringsSep " " lineContent else lineContent) sectionContent
          else if (builtins.typeOf sectionContent == "set") then
            if sectionName == "environment" || sectionName == "appenv" then
              (sectionContent.__sectionPreScript or [ ])
              ++ map (name: "export ${name}=${sectionContent.${name}}") (builtins.attrNames sectionContent)
              ++ (sectionContent.__sectionPostScript or [ ])
            else
              map (name: "${name} ${sectionContent.${name}}") (builtins.attrNames sectionContent)
          else [ ]
        );
    in
    definition:
    builtins.concatStringsSep "\n" (
      [
        (builtins.concatStringsSep "\n" (
          [ "Bootstrap: ${definition.header.Bootstrap}" ]
          ++ map
            (headerName: "${headerName}: ${definition.header.${headerName}}")
            (lib.subtractLists [ "Bootstrap" ] (builtins.attrNames definition.header))
        ))
      ]
      ++ map
        (sectionName: builtins.concatStringsSep "\n" (
          [ "%${sectionName}" ]
          ++ sectionMappingFunction sectionName definition.${sectionName}
        ))
        (orderAs knownPrimarySectionNames (lib.subtractLists [ "header" "apps" ] (builtins.attrNames definition)))
      ++ lib.optionals (builtins.hasAttr "apps" definition) (builtins.concatLists (map
        (appName:
        map
          (sectionName: builtins.concatStringsSep "\n" (
            [ "%${sectionName} ${appName}" ]
            ++ sectionMappingFunction sectionName definition.apps.${appName}.${sectionName}
          ))
          (orderAs knownAppSectionNames (builtins.attrNames definition.apps.${appName}))
        )
        (builtins.attrNames definition.apps)
      ))
    );
in
{
  inherit
    knownPrimarySectionNamesDefault
    knownAppSectionNamesDefault
    toSingularityDef
    ;
}
