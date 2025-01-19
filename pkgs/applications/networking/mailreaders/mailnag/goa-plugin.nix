{
  lib,
  fetchFromGitHub,
  python3Packages,
  gobject-introspection,
  gnome-online-accounts,
}:

python3Packages.buildPythonPackage rec {
  pname = "mailnag-goa-plugin";
  version = "2.0.0";

  src = fetchFromGitHub {
    owner = "pulb";
    repo = "mailnag-goa-plugin";
    rev = "v${version}";
    sha256 = "0bij6cy96nhq7xzslx0fnhmiac629h0x4wgy67k4i4npwqw10680";
  };

  nativeBuildInputs = [
    gobject-introspection
  ];

  buildInputs = [
    gnome-online-accounts
  ];

  meta = {
    description = "Mailnag GNOME Online Accounts plugin";
    homepage = "https://github.com/pulb/mailnag-goa-plugin";
    license = lib.licenses.gpl2;
    platforms = lib.platforms.linux;
    maintainers = with lib.maintainers; [ doronbehar ];
  };
}
