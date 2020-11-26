{ lib
, stdenv
, fetchurl
, autoPatchelfHook
, wrapGAppsHook
, dpkg
, atomEnv
, libuuid
, pulseaudio
, at-spi2-atk
, coreutils
, gawk
, xdg_utils
, systemd }:

stdenv.mkDerivation rec {
  pname = "teams";
  version = "1.3.00.25560";

  src = fetchurl {
    url = "https://packages.microsoft.com/repos/ms-teams/pool/main/t/teams/teams_${version}_amd64.deb";
    sha256 = "0kpcd9q6v2qh0dzddykisdbi3djbxj2rl70wchlzrb6bx95hkzmc";
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
  ];

  preFixup = ''
    gappsWrapperArgs+=(--prefix PATH : "${coreutils}/bin:${gawk}/bin:${xdg_utils}/bin")
  '';

  installPhase = ''
    mkdir -p $out/{opt,bin}

    mv share/teams $out/opt/
    mv share $out/share

    substituteInPlace $out/share/applications/teams.desktop \
      --replace /usr/bin/ ""

    ln -s $out/opt/teams/teams $out/bin/

    # Work-around screen sharing bug
    # https://docs.microsoft.com/en-us/answers/questions/42095/sharing-screen-not-working-anymore-bug.html
    rm $out/opt/teams/resources/app.asar.unpacked/node_modules/slimcore/bin/rect-overlay
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
  '';

  meta = with stdenv.lib; {
    description = "Microsoft Teams";
    homepage = "https://teams.microsoft.com";
    downloadPage = "https://teams.microsoft.com/downloads";
    license = licenses.unfree;
    maintainers = [ maintainers.liff ];
    platforms = [ "x86_64-linux" ];
  };
}
