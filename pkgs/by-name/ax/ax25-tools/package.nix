{
  lib,
  stdenv,
  fetchFromGitHub,
  autoreconfHook,
  libax25,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "ax25-tools";
  version = "0.0.10-rc5";

  strictDeps = true;

  nativeBuildInputs = [ autoreconfHook ];

  buildInputs = [ libax25 ];

  # src from linux-ax25.in-berlin.de remote has been
  # unreliable, pointing to github mirror from the radiocatalog
  src = fetchFromGitHub {
    #owner = "radiocatalog";
    owner = "sarcasticadmin";
    repo = "ax25-tools";
    #tag = "ax25-tools-${finalAttrs.version}";
    rev = "a76dbadcbea05941eda0c166b35275994fd32792";
    hash = "sha256-L2tkL/UuP/uf76Q3H9UkEv/pzqTRmbDTwqg3mwTc3u8=";
  };

  configureFlags = [
    "--sysconfdir=/etc"
    "--localstatedir=/var/lib"
  ];

  meta = with lib; {
    description = "Non-GUI tools used to configure an AX.25 enabled computer";
    homepage = "https://linux-ax25.in-berlin.de/wiki/Main_Page";
    license = licenses.lgpl21Only;
    maintainers = with maintainers; [ sarcasticadmin ];
    platforms = platforms.linux;
  };
})
