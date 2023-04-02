{ stdenvNoCC
, stdenv
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

  meta = with lib; {
    description = "Dead simple CLI Display Manager on TTY";
    homepage = "https://github.com/tvrzna/emptty";
    license = licenses.mit;
    maintainers = with maintainers; [ the-argus ];
    # many undefined functions
    broken = stdenv.isDarwin;
  };
}
