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
  version = "1.2.00.32451";

  src = fetchurl {
    url = "https://packages.microsoft.com/repos/ms-teams/pool/main/t/teams/teams_${version}_amd64.deb";
    sha256 = "1p053kg5qksr78v2h7cxia5mb9kzgfwm6n99x579vfx48kka1n18";
  };

  nativeBuildInputs = [ dpkg autoPatchelfHook wrapGAppsHook ];

  unpackCmd = "dpkg -x $curSrc .";

  buildInputs = atomEnv.packages ++ [
    libuuid
    at-spi2-atk
  ];

  runtimeDependencies = [
    systemd.lib
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
      --replace /usr/bin/ $out/bin/

    ln -s $out/opt/teams/teams $out/bin/
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
