{ stdenv
, lib
, fetchFromGitHub
, cmake
, mono
, dotnet-sdk
, which
, pkg-config
, gtk2
, libappindicator-gtk2
, lzma
, libselinux
, libsepol
, fribidi
, libthai
, libdatrie
, xorg
, openvpn
, stunnel
}:

stdenv.mkDerivation rec {
  pname = "eddie-ui";
  version = "2.20.0";

  arch = if stdenv.system == "i686-linux"
    then "x86"
    else "x64";

  src = fetchFromGitHub {
    owner = "AirVPN";
    repo = "Eddie";
    rev = version;
    sha256 = "0wack2xc5vk2b5i6knhqqcppdc3cml1swys3kprdpazrcim79yvg";
  };

  buildInputs = [ openvpn mono stunnel ];
  nativeBuildInputs = [
    pkg-config which cmake dotnet-sdk gtk2 lzma.dev libappindicator-gtk2.dev
    libselinux libsepol fribidi libthai libdatrie xorg.libXdmcp
  ];

  dontUseCmakeConfigure = true;

  postPatch = ''
    # Fix libappindicator include directory
    substituteInPlace src/UI.GTK.Linux.Tray/CMakeLists.txt \
      --replace '/usr/include/libappindicator-0.1' '${libappindicator-gtk2.dev}/include/libappindicator-0.1';

    # doesn't build with '-static' option, so removing it in line 35
    substituteInPlace src/App.CLI.Linux.Elevated/build.sh --replace '-static -pthread' '-pthread'

    chmod -R +w .
    find . -type f -iname "*.sh" -exec chmod +x {} \;
    patchShebangs .
  '';

  buildPhase = ''
    # Compile C# sources
    xbuild /verbosity:minimal /p:Configuration="Release" /p:Platform="$arch" src/eddie2.linux.ui.sln

    # Compile C sources (Tray)
    cd src/UI.GTK.Linux.Tray
    ./build-$arch.sh
    cd ../..

    # Compile C sources
    src/eddie.linux.postbuild.sh "src/App.Forms.Linux/bin/$arch/Release/" ui $arch Release
  '';

  installPhase = ''
    runHook preInstall

    mkdir -p $out/bin
    mkdir -p $out/lib/eddie-ui
    cp repository/linux_arch/bundle/eddie-ui/usr/bin/eddie-ui $out/bin/eddie-ui
    substituteInPlace $out/bin/eddie-ui --replace '/usr/' $out/
    chmod +x $out/bin/eddie-ui
    cp -r ./src/App.Forms.Linux/bin/$arch/Release/* $out/lib/eddie-ui
    mv $out/lib/eddie-ui/App.Forms.Linux.exe $out/lib/eddie-ui/eddie-ui.exe
    mkdir -p $out/share/eddie-ui/lang
    cp common/cacert.pem $out/share/eddie-ui/
    cp common/icon.png $out/share/eddie-ui/
    cp common/icon_gray.png $out/share/eddie-ui/
    cp common/icon.png $out/share/eddie-ui/tray.png
    cp common/icon_gray.png $out/share/eddie-ui/tray_gray.png
    cp common/iso-3166.json $out/share/eddie-ui/iso-3166.json
    cp common/lang/inv.json $out/share/eddie-ui/lang/inv.json

    runHook postInstall
  '';

  meta = with lib; {
    description = "AirVPN GUI Client";
    longDescription = ''
        Eddie is a OpenVPN GUI for AirVPN. AirVPN is based on OpenVPN and operated by activists and hacktivists in defence of net neutrality, privacy and against censorship.
    '';
    homepage = "https://eddie.website/";
    changelog = "https://eddie.website/changelog/?software=client&format=html";
    maintainers = with maintainers; [vanbeast];
    license = licenses.gpl3Plus;
    platforms = platforms.linux;
  };
}
