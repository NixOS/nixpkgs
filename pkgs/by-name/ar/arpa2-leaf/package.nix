{
  lib,
  stdenv,
  fetchFromGitLab,
  cmake,
  arpa2cm,
  quickder,
  quickmem,
  quick-sasl,
  lillydap,
  nix-update-script,
}:

stdenv.mkDerivation (finalAttrs: {
  # leaf is already used
  pname = "arpa2-leaf";
  version = "0.3";

  src = fetchFromGitLab {
    owner = "arpa2";
    repo = "leaf";
    tag = "v${finalAttrs.version}";
    hash = "sha256-I2fJ3QkVFRRk9VVSQd0UKl01NDTYo9UGVhrL/mdy0vE=";
  };

  strictDeps = true;

  nativeBuildInputs = [
    cmake
  ];

  buildInputs = [
    arpa2cm
    quickder
    quickmem
    quick-sasl
    lillydap
  ];

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "LDAP Extended Attribute Filter";
    homepage = "https://gitlab.com/arpa2/leaf";
    changelog = "https://gitlab.com/arpa2/leaf/-/blob/v${finalAttrs.version}/CHANGES";
    license = lib.licenses.bsd2;
    teams = with lib.teams; [ ngi ];
    maintainers = with lib.maintainers; [ ethancedwards8 ];
    platforms = lib.platforms.linux;
  };
})
