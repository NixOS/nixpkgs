{
  buildGoModule,
  fetchFromGitHub,
  lib,
}:

buildGoModule (finalAttrs: {
  pname = "oh";
  version = "0.8.3";

  src = fetchFromGitHub {
    owner = "michaelmacinnis";
    repo = "oh";
    rev = "v${finalAttrs.version}";
    sha256 = "sha256-ryIh6MRIOVZPm2USpJC69Z/upIXGUHgcd17eZBA9Edc=";
  };

  vendorHash = "sha256-Qma5Vk0JO/tTrZanvTCE40LmjeCfBup3U3N7gyhfp44=";

  meta = {
    homepage = "https://github.com/michaelmacinnis/oh";
    description = "New Unix shell";
    mainProgram = "oh";
    license = lib.licenses.mit;
  };

  passthru = {
    shellPath = "/bin/oh";
  };
})
