{ lib
, stdenv
, fetchurl
, installShellFiles
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "mksh";
  version = "59c";

  src = fetchurl {
    urls = [
      "http://www.mirbsd.org/MirOS/dist/mir/mksh/mksh-R${finalAttrs.version}.tgz"
      "http://pub.allbsd.org/MirOS/dist/mir/mksh/mksh-R${finalAttrs.version}.tgz"
    ];
    hash = "sha256-d64WZaM38cSMYda5Yds+UhGbOOWIhNHIloSvMfh7xQY=";
  };

  strictDeps = true;

  nativeBuildInputs = [
    installShellFiles
  ];

  dontConfigure = true;

  buildPhase = ''
    runHook preBuild
    sh ./Build.sh -r
    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall
    install -D mksh $out/bin/mksh
    install -D dot.mkshrc $out/share/mksh/mkshrc
    installManPage mksh.1
    runHook postInstall
  '';

  passthru = {
    shellPath = "/bin/mksh";
  };

  meta = {
    homepage = "http://www.mirbsd.org/mksh.htm";
    description = "MirBSD Korn Shell";
    longDescription = ''
      The MirBSD Korn Shell is a DFSG-free and OSD-compliant (and OSI
      approved) successor to pdksh, developed as part of the MirOS
      Project as native Bourne/POSIX/Korn shell for MirOS BSD, but
      also to be readily available under other UNIX(R)-like operating
      systems.
    '';
    license = with lib.licenses; [ miros isc unicode-dfs-2016 ];
    maintainers = with lib.maintainers; [ AndersonTorres joachifm ];
    platforms = lib.platforms.unix;
  };
})
# TODO [ AndersonTorres ]: lksh
# TODO [ AndersonTorres ]: a more accurate licensing info
