{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule (finalAttrs: {
  pname = "gotty";
  version = "1.8.0";

  src = fetchFromGitHub {
    owner = "sorenisanerd";
    repo = "gotty";
    rev = "v${finalAttrs.version}";
    sha256 = "sha256-+ZcFKMx9wfty3DIgN9lb9N9CZaZfO76VwvuzWR9yrvo=";
  };

  vendorHash = "sha256-MvNCq1kWhfVJz4h6G0yAwJd8Z4xRtcu2WjeEhoTW5L8=";

  # upstream did not update the tests, so they are broken now
  # https://github.com/sorenisanerd/gotty/issues/13
  doCheck = false;

  meta = {
    description = "Share your terminal as a web application";
    mainProgram = "gotty";
    homepage = "https://github.com/sorenisanerd/gotty";
    maintainers = with lib.maintainers; [ prusnak ];
    license = lib.licenses.mit;
  };
})
