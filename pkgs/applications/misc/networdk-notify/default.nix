{ stdenv, pythonPackages, fetchFromGitHub }:

pythonPackages.buildPythonPackage rec {
  name = "networkd-notify-unstable-2016-05-17";
  version = "690b848b8baf8a8254d8402a7e2d5168285f38f7";

  src = fetchFromGitHub {
    owner = "wavexx";
    repo = "networkd-notify";
    rev = version;
    sha256 = "006d8qmmk0jg0a3fbl2q934wmmhx9n7c156i34i9zgzapdhhacq6";
  };

  propagatedBuildInputs = with pythonPackages; [ dbus-python ];

  phases = [ "unpackPhase" "installPhase" ];

  installPhase = ''
    install -D -m755 networkd-notify $out/bin/networkd-notify
  '';

  meta = with stdenv.lib; {
    description = "desktop notification integration for networkd";
    license = licenses.gpl3Plus;
    maintainers = [ maintainers.matthiasbeyer ];
  };
}
