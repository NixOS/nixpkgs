{
  stdenv,
  lib,
  fetchFromGitLab,
  makeWrapper,
  coreutils,
  versionCheckHook,
  jre,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "oscanner";
  version = "1.0.6";

  src = fetchFromGitLab {
    group = "kalilinux";
    owner = "packages";
    repo = "oscanner";
    tag = "kali/${finalAttrs.version}-1kali3";
    hash = "sha256-zb6u01wv+PDQp958qmI54upH+hKk8gltqZHGMEMMA5E=";
  };
  strictDeps = true;

  nativeBuildInputs = [ makeWrapper ];

  sourceRoot = "source";

  # start launcher from share directory which contains jar files
  postPatch = ''
    for i in *.sh;do
      sed -i '4i cd "$(dirname "$(readlink -f "$0")")"/../share/oscanner' "$i"
    done
  '';

  dontBuild = true;
  dontConfigure = true;

  installPhase = ''
    runHook preInstall
    install -dm755 $out/share/oscanner

    install -D -m644 COPYING $out/share/doc/oscanner/COPYING

    # install launchers
    install -Dm755 oscanner.sh $out/bin/oscanner
    install -Dm755 reportviewer.sh $out/bin/reportviewer

    # cleanup before copy
    rm -f *.exe COPYING oscanner.sh reportviewer.sh

    cp -r . $out/share/oscanner

    for bin in $out/bin/*;do
      wrapProgram $bin \
        --prefix PATH : ${
          lib.makeBinPath [
            jre
            coreutils # required for launcher directory switch
          ]
        }
    done

    runHook postInstall
  '';
  nativeInstallCheckInputs = [ versionCheckHook ];
  versionCheckProgramArg = "-v";
  doInstallCheck = true;

  meta = {
    description = "An Oracle assessment framework developed in Java";
    homepage = "https://www.kali.org/tools/oscanner/";
    license = lib.licenses.gpl2;
    platforms = lib.platforms.all;
    maintainers = with lib.maintainers; [ makefu ];
    mainProgram = "oscanner";
  };
})
