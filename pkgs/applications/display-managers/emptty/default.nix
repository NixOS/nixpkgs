{ buildGoModule
, fetchFromGitHub
, lib
, libX11
, pam
, stdenv
}:

buildGoModule rec {
  pname = "emptty";
  version = "0.12.1";

  src = fetchFromGitHub {
    owner = "tvrzna";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-9qNAQBmcFKPpJ+AqfOy3emA1fvqI/XaT39KwI5fpXHU=";
  };

  buildInputs = [ pam libX11 ];

  vendorHash = "sha256-PLyemAUcCz9H7+nAxftki3G7rQoEeyPzY3YUEj2RFn4=";

  meta = with lib; {
    description = "Dead simple CLI Display Manager on TTY";
    homepage = "https://github.com/tvrzna/emptty";
    license = licenses.mit;
    maintainers = with maintainers; [ urandom ];
    # many undefined functions
    broken = stdenv.isDarwin;
    mainProgram = "emptty";
  };
}
