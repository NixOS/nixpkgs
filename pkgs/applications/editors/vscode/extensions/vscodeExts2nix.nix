# based on the passed vscode will stdout a nix expression with the installed vscode extensions
{ lib
, vscodeDefault
, writeShellScriptBin
}:

##User input
{ vscode             ? vscodeDefault
, extensionsToIgnore ? []
# will use those extensions to get sha256 if still exists when executed.
, extensions         ? []
}:
let
  mktplcExtRefToFetchArgs = import ./mktplcExtRefToFetchArgs.nix;
in
writeShellScriptBin "vscodeExts2nix" ''
  echo '['

  for line in $(${vscode}/bin/code --list-extensions --show-versions \
    ${lib.optionalString (extensionsToIgnore != []) ''
      | grep -v -i '^\(${lib.concatMapStringsSep "\\|" (e : "${e.publisher}.${e.name}") extensionsToIgnore}\)'
    ''}
  ) ; do
    [[ $line =~ ([^.]*)\.([^@]*)@(.*) ]]
    name=''${BASH_REMATCH[2]}
    publisher=''${BASH_REMATCH[1]}
    version=''${BASH_REMATCH[3]}

    extensions="${lib.concatMapStringsSep "." (e : "${e.publisher}${e.name}@${e.sha256}") extensions}"
    reCurrentExt=$publisher$name"@([^.]*)"
    if [[ $extensions =~ $reCurrentExt ]]; then
      sha256=''${BASH_REMATCH[1]}
    else
      sha256=$(
        nix-prefetch-url "${(mktplcExtRefToFetchArgs {publisher = ''"$publisher"''; name = ''"$name"''; version = ''"$version"'';}).url}" 2> /dev/null
      )
    fi

    echo "{ name = \"''${name}\"; publisher = \"''${publisher}\"; version = \"''${version}\"; sha256 = \"''${sha256}\";  }"
  done


  echo ']'
''
