{
  stdenvNoCC,
  fetchFromGitHub,
  gradle,
  jre,
  tesseract5,
  lib,
  makeWrapper,
}:
stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "audiveris";
  version = "5.3.1";

  nativeBuildInputs = [
    gradle
    makeWrapper
  ];

  src = fetchFromGitHub {
    owner = "Audiveris";
    repo = "audiveris";
    rev = "${finalAttrs.version}";
    hash = "sha256-feUaNnAZRZHJd+NvwgM+YwaEXjH9GqlkPH5BgWzubYs=";
  };

  # we usually don't have access to the commit hashes
  postPatch = ''
    substituteInPlace build.gradle \
      --replace "git rev-parse --short HEAD" "echo nixos"
    echo "compileJava.options.encoding = 'UTF-8'" >> build.gradle
  '';

  gradleUpdateScript = ''
    runHook preBuild

    gradle nixDownloadDeps -Dos.family=linux -Dos.arch=amd64
    gradle nixDownloadDeps -Dos.family=linux -Dos.arch=aarch64
    gradle nixDownloadDeps -Dos.name='mac os x' -Dos.arch=amd64
    gradle nixDownloadDeps -Dos.name='mac os x' -Dos.arch=aarch64
  '';

  mitmCache = gradle.fetchDeps {
    inherit (finalAttrs) pname;
    data = ./deps.json;
  };

  installPhase = ''
    runHook preInstall
    mkdir $out
    cat build/distributions/Audiveris-${finalAttrs.version}.tar |
      (cd $out;tar xv --strip-components=1)
    rm $out/bin/Audiveris.bat
    wrapProgram $out/bin/Audiveris \
      --set JAVA_HOME ${jre} \
      --set TESSDATA_PREFIX "${tesseract5}/share/tessdata"
    runHook postInstall
  '';

  meta = with lib; {
    description = "open-source optical music recognition engine";
    homepage = "https://audiveris.github.io/audiveris/";
    mainProgram = "Audiveris";
    sourceProvenance = with sourceTypes; [
      fromSource
      binaryBytecode # deps
      binaryNativeCode # deps (tesseract, leptonica)
    ];
    license = licenses.agpl3Plus;
    maintainers = with maintainers; [ gm6k ];
    platforms = [
      "x86_64-linux"
      "aarch64-linux"
      "x86_64-darwin"
      "aarch64-darwin"
    ];
  };
})
