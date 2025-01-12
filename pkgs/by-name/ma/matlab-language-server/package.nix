{
  lib,
  buildNpmPackage,
  fetchFromGitHub,
  fetchpatch,
}:

buildNpmPackage {
  pname = "matlab-language-server";
  version = "1.1.6";

  src = fetchFromGitHub {
    owner = "mathworks";
    repo = "matlab-language-server";
    # Upstream doesn't tag commits unfortunatly, but lists versions and dates
    # in README... See complaint at:
    # https://github.com/mathworks/MATLAB-language-server/issues/24
    rev = "c8c901956e3bbfbd6eab440a1b60c3fe016cf567";
    hash = "sha256-D03gXyrvPYOMkJI2YuHfPAnWdXTz5baemykQ5j9L0rs=";
  };
  patches = [
    # https://github.com/mathworks/MATLAB-language-server/pull/23
    (fetchpatch {
      url = "https://github.com/mathworks/MATLAB-language-server/commit/56374de620b4855529c4136539f52ab6030e2c92.patch";
      hash = "sha256-F38ATP+eap0SnxQoib1JwIvNCFfB7g8EtXI9+iK5+HA=";
    })
  ];

  npmDepsHash = "sha256-P3MSrwk6FVt4lK58pjwy0YOg2UZI0TG8uXjqCPudgTE=";

  npmBuildScript = "package";

  meta = {
    description = "Language Server for MATLAB® code";
    homepage = "https://github.com/mathworks/MATLAB-language-server";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ doronbehar ];
    mainProgram = "matlab-language-server";
  };
}
