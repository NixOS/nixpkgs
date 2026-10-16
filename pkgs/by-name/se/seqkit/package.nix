{
  lib,
  fetchFromGitHub,
  buildGoModule,
}:

buildGoModule (finalAttrs: {
  pname = "seqkit";
  version = "2.14.0";

  src = fetchFromGitHub {
    owner = "shenwei356";
    repo = "seqkit";
    rev = "v${finalAttrs.version}";
    sha256 = "sha256-yKgkzhwUMD37AY3VvX+jShWosI7Eda8TRCJEi0Wz748=";
  };

  vendorHash = "sha256-w2FKHUkxvkQwMDmiVVyKItPCwmVURTERIgrvvjX97CI=";

  meta = {
    description = "Cross-platform and ultrafast toolkit for FASTA/Q file manipulation";
    homepage = "https://github.com/shenwei356/seqkit";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ bzizou ];
  };
})
