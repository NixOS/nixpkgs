{ stdenvNoCC
, makeWrapper
, emptty-unwrapped
, additionalPathEntries ? [ ]
, util-linuxMinimal
, getent
, dbus
, xorg
, lib
, systemPath ? null
, ...
}:
let
  runtimePath = lib.makeBinPath ([
    getent
    util-linuxMinimal
    dbus
    xorg.xauth
  ]
  ++ (lib.lists.optionals (systemPath != null) [ systemPath ])
  ++ additionalPathEntries);
in
stdenvNoCC.mkDerivation {
  pname = "emptty";

  inherit (emptty-unwrapped) version;
  src = emptty-unwrapped;

  buildInputs = [ makeWrapper ];

  installPhase = ''
    mkdir -p $out
    cp -r $src/* $out
  '';

  postFixup = ''
    wrapProgram \
        $out/bin/emptty \
        --prefix PATH ":" ${runtimePath}
  '';
}
