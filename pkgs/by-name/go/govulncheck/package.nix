{
  lib,
  buildGoLatestModule,
  fetchFromGitHub,
  replaceVars,
  versionCheckHook,
}:

buildGoLatestModule (finalAttrs: {
  pname = "govulncheck";
  version = "1.2.0";

  src = fetchFromGitHub {
    owner = "golang";
    repo = "vuln";
    tag = "v${finalAttrs.version}";
    hash = "sha256-15DTxzlK7mkUt7KCwsV5+E5dPopCwFylI0fmVB0LDEo=";
  };

  patches = [
    # patch in version information
    (replaceVars ./version.patch {
      inherit (finalAttrs) version;
    })
  ];

  vendorHash = "sha256-+hJtGG9GGDb3D9Cgm7hreySjOlXXsc7HxHcoS2Cxfbs=";

  subPackages = [
    "cmd/govulncheck"
  ];

  # Vendoring breaks tests
  doCheck = false;

  ldflags = [
    "-s"
    "-w"
  ];

  nativeInstallCheckInputs = [ versionCheckHook ];

  doInstallCheck = true;

  versionCheckProgramArg = [ "--version" ];

  meta = {
    homepage = "https://pkg.go.dev/golang.org/x/vuln/cmd/govulncheck";
    downloadPage = "https://github.com/golang/vuln";
    changelog = "https://github.com/golang/vuln/releases/tag/${finalAttrs.src.tag}";
    description = "Database client and tools for the Go vulnerability database, also known as vuln";
    mainProgram = "govulncheck";
    longDescription = ''
      Govulncheck reports known vulnerabilities that affect Go code. It uses
      static analysis of source code or a binary's symbol table to narrow down
      reports to only those that could affect the application.

      By default, govulncheck makes requests to the Go vulnerability database at
      https://vuln.go.dev. Requests to the vulnerability database contain only
      module paths, not code or other properties of your program. See
      https://vuln.go.dev/privacy.html for more. Set the GOVULNDB environment
      variable to specify a different database, which must implement the
      specification at https://go.dev/security/vuln/database.

      Govulncheck looks for vulnerabilities in Go programs using a specific
      build configuration. For analyzing source code, that configuration is the
      operating system, architecture, and Go version specified by GOOS, GOARCH,
      and the “go” command found on the PATH. For binaries, the build
      configuration is the one used to build the binary. Note that different
      build configurations may have different known vulnerabilities. For
      example, a dependency with a Windows-specific vulnerability will not be
      reported for a Linux build.
    '';
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [
      jk
      SuperSandro2000
    ];
  };
})
