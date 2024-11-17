{
  lib,
  stdenv,
  fetchFromGitHub,
  pkg-config,
  libpcap,
  autoreconfHook,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "knock";
  version = "0.8";

  src = fetchFromGitHub {
    owner = "jvinet";
    repo = "knock";
    rev = "refs/tags/v${finalAttrs.version}";
    hash = "sha256-GOg6wovyr6J5qHm5EsOxrposFtwwx/FyJs7g0dagFmk=";
  };

  nativeBuildInputs = [
    autoreconfHook
    pkg-config
  ];

  buildInputs = [
    libpcap
  ];

  postPatch = ''
    substituteInPlace Makefile.am \
      --replace-fail "sbin_PROGRAMS = knockd" "bin_PROGRAMS += knockd" \
      --replace-fail "dist_sbin_SCRIPTS = src/knock_helper_ipt.sh" "" \
      --replace-fail "sysconf_DATA = knockd.conf" "" \
      --replace-fail "dist_doc_DATA = README.md TODO ChangeLog COPYING" "" \
      --replace-fail "src/knock_helper_ipt.sh" ""
  '';

  meta = {
    description = "A port-knocking implementation";
    homepage = "https://github.com/jvinet/knock";
    changelog = "https://github.com/jvinet/knock/releases";
    license = lib.licenses.gpl2Plus;
    maintainers = with lib.maintainers; [ theobori ];
    mainProgram = "knock";
    platforms = lib.platforms.unix;
  };
})
