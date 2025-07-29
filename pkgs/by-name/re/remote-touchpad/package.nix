{
  buildGoModule,
  fetchFromGitHub,
  lib,
  libXi,
  libXrandr,
  libXt,
  libXtst,
}:

buildGoModule rec {
  pname = "remote-touchpad";
  version = "1.5.0";

  src = fetchFromGitHub {
    owner = "unrud";
    repo = "remote-touchpad";
    rev = "v${version}";
    sha256 = "sha256-UZjbU9Ti5+IjcxIf+LDWlcqxb4kMIwa8zHmZDdZbnw8=";
  };

  buildInputs = [
    libXi
    libXrandr
    libXt
    libXtst
  ];
  tags = [ "portal,x11" ];

  vendorHash = "sha256-4TJ9Nok1P3qze69KvrwFo5sMJ4nDYhDNuApsNlZLWCI=";

  meta = with lib; {
    description = "Control mouse and keyboard from the web browser of a smartphone";
    mainProgram = "remote-touchpad";
    homepage = "https://github.com/unrud/remote-touchpad";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ schnusch ];
    platforms = platforms.linux;
  };
}
