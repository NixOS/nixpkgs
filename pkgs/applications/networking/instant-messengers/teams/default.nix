{ lib
, stdenv
, fetchurl
, autoPatchelfHook
, wrapGAppsHook
, dpkg
, atomEnv
, libuuid
, libappindicator-gtk3
, pulseaudio
, at-spi2-atk
, coreutils
, gawk
, xdg-utils
, systemd }:

stdenv.mkDerivation rec {
  pname = "teams";
  version = "1.4.00.7556";

  src = fetchurl {
    url = "https://packages.microsoft.com/repos/ms-teams/pool/main/t/teams/teams_${version}_amd64.deb";
    sha256 = "0yak3jxh0gdn57wjss0s7sdjssf1b70j0klrcpv66bizqvw1xl7b";
  };

  nativeBuildInputs = [ dpkg autoPatchelfHook wrapGAppsHook ];

  unpackCmd = "dpkg -x $curSrc .";

  buildInputs = atomEnv.packages ++ [
    libuuid
    at-spi2-atk
  ];

  runtimeDependencies = [
    (lib.getLib systemd)
    pulseaudio
    libappindicator-gtk3
  ];

  preFixup = ''
    gappsWrapperArgs+=(--prefix PATH : "${coreutils}/bin:${gawk}/bin:${xdg-utils}/bin")
    gappsWrapperArgs+=(--add-flags --disable-namespace-sandbox)
    gappsWrapperArgs+=(--add-flags --disable-setuid-sandbox)
  '';

  installPhase = ''
    runHook preInstall

    mkdir -p $out/{opt,bin}

    mv share/teams $out/opt/
    mv share $out/share

    substituteInPlace $out/share/applications/teams.desktop \
      --replace /usr/bin/ ""

    ln -s $out/opt/teams/teams $out/bin/

    # Work-around screen sharing bug
    # https://docs.microsoft.com/en-us/answers/questions/42095/sharing-screen-not-working-anymore-bug.html
    rm $out/opt/teams/resources/app.asar.unpacked/node_modules/slimcore/bin/rect-overlay

    runHook postInstall
  '';

  dontAutoPatchelf = true;

  # Includes runtimeDependencies in the RPATH of the included Node modules
  # so that dynamic loading works. We cannot use directly runtimeDependencies
  # here, since the libraries from runtimeDependencies are not propagated
  # to the dynamically loadable node modules because of a condition in
  # autoPatchElfHook since *.node modules have Type: DYN (Shared object file)
  # instead of EXEC or INTERP it expects.
  # Fixes: https://github.com/NixOS/nixpkgs/issues/85449
  postFixup = ''
    autoPatchelf "$out"

    runtime_rpath="${lib.makeLibraryPath runtimeDependencies}"

    for mod in $(find "$out/opt/teams" -name '*.node'); do
      mod_rpath="$(patchelf --print-rpath "$mod")"

      echo "Adding runtime dependencies to RPATH of Node module $mod"
      patchelf --set-rpath "$runtime_rpath:$mod_rpath" "$mod"
    done;

    # fix for https://docs.microsoft.com/en-us/answers/questions/298724/open-teams-meeting-link-on-linux-doens39t-work.html?childToView=309406#comment-309406
    # while we create the wrapper ourselves, gappsWrapperArgs leads to the same issue
    # another option would be to introduce gappsWrapperAppendedArgs, to allow control of positioning
    substituteInPlace "$out/bin/teams" --replace '.teams-wrapped"  --disable-namespace-sandbox --disable-setuid-sandbox "$@"' '.teams-wrapped" "$@" --disable-namespace-sandbox --disable-setuid-sandbox'
  '';

  meta = with lib; {
    description = "Microsoft Teams";
    homepage = "https://teams.microsoft.com";
    downloadPage = "https://teams.microsoft.com/downloads";
    license = licenses.unfree;
    maintainers = [ maintainers.liff ];
    platforms = [ "x86_64-linux" ];
  };
}
