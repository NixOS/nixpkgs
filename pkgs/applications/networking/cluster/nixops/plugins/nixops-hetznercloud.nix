{ lib
, buildPythonPackage
, fetchFromGitHub
, unstableGitUpdater
, poetry-core
, hcloud
, nixops
, typing-extensions
}:

buildPythonPackage {
  pname = "nixops-hetznercloud";
  version = "unstable-2023-02-19";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "lukebfox";
    repo = "nixops-hetznercloud";
    rev = "e14f340f7ffe9e2aa7ffbaac0b8a2e3b4cc116b3";
    hash = "sha256-IsRJUUAfN6YXcue80qlcunkawUtgMiMU8mM6DP+7Cm4=";
  };

  postPatch = ''
    substituteInPlace pyproject.toml \
    --replace poetry.masonry.api poetry.core.masonry.api \
    --replace "poetry>=" "poetry-core>="
  '';

  nativeBuildInputs = [
    poetry-core
  ];

  buildInputs = [
    nixops
  ];

  propagatedBuildInputs = [
    hcloud
    typing-extensions
  ];

  pythonImportsCheck = [ "nixops_hetznercloud" ];

  passthru.updateScript = unstableGitUpdater {};

  meta = with lib; {
    description = "A NixOps plugin supporting Hetzner Cloud deployments";
    homepage = "https://github.com/lukebfox/nixops-hetznercloud";
    license = licenses.lgpl3Only;
    maintainers = with maintainers; [ lukebfox ];
  };
}
