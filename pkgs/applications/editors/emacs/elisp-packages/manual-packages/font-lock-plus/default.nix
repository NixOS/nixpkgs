{
  lib,
  fetchFromGitHub,
  trivialBuild,
}:

trivialBuild {
  pname = "font-lock-plus";
  version = "208+unstable=2018-01-01";

  src = fetchFromGitHub {
    owner = "emacsmirror";
    repo = "font-lock-plus";
    rev = "f2c1ddcd4c9d581bd32be88fad026b49f98b6541";
    hash = "sha256-lFmdVMXIIXZ9ZohAJw5rhxpTv017qIyzmpuKOWDdeJ4=";
  };

  meta = with lib; {
    homepage = "https://github.com/emacsmirror/font-lock-plus";
    description = "Enhancements to standard library font-lock.el";
    license = licenses.gpl2Plus;
  };
}
