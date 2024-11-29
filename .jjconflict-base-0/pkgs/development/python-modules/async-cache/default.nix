{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
}:

buildPythonPackage rec {
  pname = "async-cache";
  version = "1.1.1";

  src = fetchFromGitHub {
    owner = "iamsinghrajat";
    repo = "async-cache";
    rev = "9925f07920e6b585dc6345f49b7f477b3e1b8c2c"; # doesn't tag releases :(
    hash = "sha256-AVSdtWPs1c8AE5PNOq+BdXzBXkI0aeFVzxxPl/ATyU0=";
  };

  meta = with lib; {
    description = "Caching solution for asyncio";
    homepage = "https://github.com/iamsinghrajat/async-cache";
    license = licenses.mit;
    maintainers = [ maintainers.lukegb ];
  };
}
