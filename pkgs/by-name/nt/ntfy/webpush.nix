{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  pywebpush,
  py-vapid,
}:

buildPythonPackage rec {
  pname = "ntfy-webpush";
  version = "0.1.3";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "dschep";
    repo = "ntfy-webpush";
    rev = "v${version}";
    sha256 = "1dxlvq3glf8yjkn1hdk89rx1s4fi9ygg46yn866a9v7a5a83zx2n";
  };

  postPatch = ''
    # break dependency loop
    substituteInPlace setup.py \
      --replace-fail "'ntfy', " ""
  '';

  build-system = [ setuptools ];

  dependencies = [
    pywebpush
    py-vapid
  ];

  # no tests, just a script
  doCheck = false;

  meta = with lib; {
    description = "Cloudbell webpush notification support for ntfy";
    homepage = "https://dschep.github.io/ntfy-webpush/";
    license = licenses.mit;
    maintainers = [ ];
  };
}
