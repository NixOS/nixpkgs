{
  lib,
  fetchFromGitHub,
  stdenvNoCC,
  wget,
}:

stdenvNoCC.mkDerivation rec {
  pname = "junest";
  version = "7.4.10";

  src = fetchFromGitHub {
    owner = "fsquillace";
    repo = "junest";
    tag = version;
    hash = "sha256-Dq4EqmeFI1TEbnc4kQwgqe71eJJpzWm2ywt1y6fD8z4=";
  };

  dontBuild = true;

  installPhase = ''
    runHook preInstall

    mkdir -p $out/bin
    mkdir -p $out/lib
    cp -r $src/bin/ $out/
    cp -r $src/lib/ $out/
    # cp -r $src/VERSION $out/
    substituteInPlace $out/bin/junest --replace-fail '$(cat "$JUNEST_BASE"/VERSION)' ${version}
    substituteInPlace $out/lib/core/common.sh --replace-fail "wget" ${lib.getExe wget}

    runHook postInstall
  '';

  meta = {
    description = "Arch distro that runs on top of another without root";
    homepage = "https://github.com/fsquillace/junest";
    license = lib.licenses.gpl3Only;
    mainProgram = "junest";
    maintainers = with lib.maintainers; [ jdev082 ];
    platforms = lib.platforms.linux;
  };
}
