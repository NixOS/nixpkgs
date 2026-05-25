{
  lib,
  stdenv,
  fetchFromGitHub,
  pam,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "pam-honeycreds";
  version = "1.9";
  src = fetchFromGitHub {
    owner = "ColumPaget";
    repo = "pam_honeycreds";
    rev = "v${finalAttrs.version}";
    hash = "sha256-GRJnH431foNI10g95rrtgi31DM15FWhzNq9L0SwoZoM=";
  };

  buildInputs = [ pam ];

  meta = {
    homepage = "https://github.com/ColumPaget/pam_honeycreds";
    description = "PAM module that sends warnings when fake passwords are used";
    license = lib.licenses.gpl3Only;
    platforms = lib.platforms.unix;
    maintainers = with lib.maintainers; [ h7x4 ];
  };
})
