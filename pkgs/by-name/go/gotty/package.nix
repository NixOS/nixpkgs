{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule rec {
  pname = "gotty";
  version = "1.6.0";

  src = fetchFromGitHub {
    owner = "sorenisanerd";
    repo = "gotty";
    rev = "v${version}";
    sha256 = "sha256-9J+8NZmdYg4mE8Jgs2bxcwcPyh4sVcOBYPnulVENdy0=";
  };

  vendorHash = "sha256-OcBwkA28k54rSZP66L+wdkiWPvUv7Z9pTlEK7/LXjBM=";

  # upstream did not update the tests, so they are broken now
  # https://github.com/sorenisanerd/gotty/issues/13
  doCheck = false;

  meta = with lib; {
    description = "Share your terminal as a web application";
    mainProgram = "gotty";
    homepage = "https://github.com/sorenisanerd/gotty";
    maintainers = with maintainers; [ prusnak ];
    license = licenses.mit;
  };
}
