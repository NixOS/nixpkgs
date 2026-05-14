{
  lib,
  stdenv,
  fetchFromGitHub,
  fetchpatch,
  cmake,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "ddate";
  version = "0.2.2";

  src = fetchFromGitHub {
    owner = "bo0ts";
    repo = "ddate";
    tag = "v${finalAttrs.version}";
    sha256 = "1qchxnxvghbma6gp1g78wnjxsri0b72ha9axyk31cplssl7yn73f";
  };

  patches = [
    # cmake-4 compatibility
    (fetchpatch {
      name = "cmake-4.patch";
      url = "https://github.com/bo0ts/ddate/commit/0fbae46cb004c0acc48982b8e3533556d7b2edcc.patch?full_index=1";
      hash = "sha256-EbOmZYhFN8t8E/GW9ctcvhYfQauGZnX+5ZQmrEl6F18=";
    })
  ];

  nativeBuildInputs = [ cmake ];

  meta = {
    homepage = "https://github.com/bo0ts/ddate";
    description = "Discordian version of the date program";
    license = lib.licenses.publicDomain;
    maintainers = with lib.maintainers; [ kovirobi ];
    platforms = lib.platforms.all;
    mainProgram = "ddate";
  };
})
