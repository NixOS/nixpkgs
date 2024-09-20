{
  lib,
  stdenvNoCC,
  fetchzip,
  makeWrapper,
  openjdk,
}:

stdenvNoCC.mkDerivation {
  pname = "android-studio-tools";
  version = "11076708";

  src = fetchzip {
    # The only difference between the Linux and Mac versions is a single comment at the top of all the scripts
    # Therefore, we will use the Linux version and just patch the comment
    url = "https://dl.google.com/android/repository/commandlinetools-linux-11076708_latest.zip";
    hash = "sha256-NjxJzHRT2/zZ9YzzjqaMVxpOELkDneQgc1/y1GUnZow=";
  };

  postPatch = ''
    find . -type f -not -path "./bin/*" -exec chmod -x {} \;
  '' + lib.optionalString stdenvNoCC.isDarwin ''
    for f in cmdline-tools/bin/*; do
      sed -i 's|start up script for Linux|start up script for Mac|' $f
    done
  '';

  nativeBuildInputs = [ makeWrapper ];

  dontConfigure = true;
  dontBuild = true;

  installPhase = ''
    runHook preInstall

    mkdir -p $out
    cp -r . $out

    for f in $out/bin/*; do
      wrapProgram $f --set JAVA_HOME "${openjdk}"
    done

    runHook postInstall
  '';

  meta = {
    description = "Android Studio CLI Tools";
    homepage = "https://developer.android.com/studio";
    downloadPage = "https://developer.android.com/studio";
    changelog = "https://developer.android.com/studio/releases";
    license = lib.licenses.unfree;
    maintainers = with lib.maintainers; [ pandapip1 ];
    platforms = lib.platforms.all;
    sourceProvenance = with lib.sourceTypes; [ fromSource ]; # The 'binaries' are actually shell scripts
  };
}
