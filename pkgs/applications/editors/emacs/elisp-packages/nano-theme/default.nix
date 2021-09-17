{ lib
, trivialBuild
, fetchFromGitHub
, emacs
}:

trivialBuild rec {
  pname = "nano-theme";
  version = "0.0.0+unstable=2021-06-29";

  src = fetchFromGitHub {
    owner = "rougier";
    repo  = pname;
    rev = "4a231787a32b3019f9f0abb3511a112fd54bf685";
    hash = "sha256-eco9BMKLhPuwFJb5QesbM6g3cZv3FdVvQ9fXq6D3Ifc=";
  };

  meta = {
    homepage = "https://github.com/rougier/nano-theme";
    description = "GNU Emacs / N Λ N O Theme";
    inherit (emacs.meta) platforms;
  };
}
