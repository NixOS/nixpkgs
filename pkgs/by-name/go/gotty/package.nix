{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule rec {
  pname = "gotty";
  version = "1.5.0";

  src = fetchFromGitHub {
    owner = "sorenisanerd";
    repo = "gotty";
    rev = "v${version}";
    sha256 = "sha256-VSu0ASnLmRzOGOEKqb/zB43+HxEwMpKLpbdbWY5QrEk=";
  };

  vendorHash = "sha256-XtqIiREtKg0LRnwOg8UyYrWUWJNQbCJUw+nVvaiN3GQ=";

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
