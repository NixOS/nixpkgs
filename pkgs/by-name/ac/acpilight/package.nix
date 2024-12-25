{
  lib,
  stdenv,
  fetchgit,
  python3,
  coreutils,
}:

stdenv.mkDerivation rec {
  pname = "acpilight";
  version = "1.2";

  src = fetchgit {
    url = "https://gitlab.com/wavexx/acpilight.git";
    rev = "v${version}";
    sha256 = "1r0r3nx6x6vkpal6vci0zaa1n9dfacypldf6k8fxg7919vzxdn1w";
  };

  pyenv = python3.withPackages (
    pythonPackages: with pythonPackages; [
      configargparse
    ]
  );

  postConfigure = ''
    substituteInPlace 90-backlight.rules --replace /bin ${coreutils}/bin
    substituteInPlace Makefile --replace udevadm true
  '';

  buildInputs = [ pyenv ];

  makeFlags = [ "DESTDIR=$(out) prefix=" ];

  meta = with lib; {
    homepage = "https://gitlab.com/wavexx/acpilight";
    description = "ACPI backlight control";
    license = licenses.gpl3;
    maintainers = with maintainers; [ smakarov ];
    platforms = platforms.linux;
    mainProgram = "xbacklight";
  };
}
