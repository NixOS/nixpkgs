{
  lib,
  fetchFromGitHub,
  python3,
}:

python3.pkgs.buildPythonApplication rec {
  pname = "kube-hunter";
  version = "0.6.8";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "aquasecurity";
    repo = "kube-hunter";
    tag = "v${version}";
    hash = "sha256-+M8P/VSF9SKPvq+yNPjokyhggY7hzQ9qLLhkiTNbJls=";
  };

  pythonRemoveDeps = [ "future" ];

  build-system = with python3.pkgs; [ setuptools-scm ];

  dependencies = with python3.pkgs; [
    netaddr
    netifaces
    requests
    prettytable
    urllib3
    ruamel-yaml
    packaging
    pluggy
    kubernetes
  ];

  nativeCheckInputs = with python3.pkgs; [
    pytest-cov-stub
    pytestCheckHook
    requests-mock
  ];

  postPatch = ''
    substituteInPlace setup.cfg \
      --replace "dataclasses" "" \
      --replace "kubernetes==12.0.1" "kubernetes"
  '';

  pythonImportsCheck = [ "kube_hunter" ];

  disabledTests = [
    # Test is out-dated
    "test_K8sCveHunter"
  ];

  meta = with lib; {
    description = "Tool to search issues in Kubernetes clusters";
    homepage = "https://github.com/aquasecurity/kube-hunter";
    changelog = "https://github.com/aquasecurity/kube-hunter/releases/tag/${src.tag}";
    license = licenses.asl20;
    maintainers = with maintainers; [ fab ];
    mainProgram = "kube-hunter";
  };
}
