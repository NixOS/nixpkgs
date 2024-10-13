{ lib
, mkDerivation
, fetchFromGitHub
, cmake

, withLibei ? true

, avahi
, curl
, libICE
, libSM
, libX11
, libXdmcp
, libXext
, libXinerama
, libXrandr
, libXtst
, libei
, libportal
, openssl
, pkg-config
, kdePackages
, wrapGAppsHook3
}:

mkDerivation rec {
  pname = "input-leap";
  version = "v3.0.1";

  src = fetchFromGitHub {
    owner = "input-leap";
    repo = "input-leap";
    rev = "v3.0.1";
    hash = "sha256-YF9WqIaI5SuLwU8KbN22kndJUG5eHoqy1mk8Yte0suE=";
    fetchSubmodules = true;
  };

  nativeBuildInputs = [ pkg-config cmake wrapGAppsHook3 kdePackages.qttools ];
  buildInputs = [
    curl kdePackages.qtbase avahi
    libX11 libXext libXtst libXinerama libXrandr libXdmcp libICE libSM
  ] ++ lib.optionals withLibei [ libei libportal ];

  cmakeFlags = [
    "-DINPUTLEAP_REVISION=${builtins.substring 0 8 src.rev}"
  ] ++ lib.optional withLibei "-DINPUTLEAP_BUILD_LIBEI=ON";

  dontWrapGApps = true;
  preFixup = ''
    qtWrapperArgs+=(
      "''${gappsWrapperArgs[@]}"
        --prefix PATH : "${lib.makeBinPath [ openssl ]}"
    )
  '';

  postFixup = ''
    substituteInPlace $out/share/applications/io.github.input_leap.InputLeap.desktop \
      --replace "Exec=input-leap" "Exec=$out/bin/input-leap"
  '';

  meta = {
    description = "Open-source KVM software";
    longDescription = ''
      Input Leap is software that mimics the functionality of a KVM switch, which historically
      would allow you to use a single keyboard and mouse to control multiple computers by
      physically turning a dial on the box to switch the machine you're controlling at any
      given moment. Input Leap does this in software, allowing you to tell it which machine
      to control by moving your mouse to the edge of the screen, or by using a keypress
      to switch focus to a different system.
    '';
    homepage = "https://github.com/input-leap/input-leap";
    license = lib.licenses.gpl2Plus;
    maintainers = with lib.maintainers; [ kovirobi phryneas twey shymega ];
    platforms = lib.platforms.linux;
  };
}
