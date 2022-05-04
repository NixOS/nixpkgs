# Patched lldb for Rust language support.
{ lldb_12, fetchFromGitHub }:
let
  llvmSrc = fetchFromGitHub {
    owner = "vadimcn";
    repo = "llvm-project";
    rev = "f2e9ff34256cd8c6feaf14359f88ad3f538ed687";
    sha256 = "sha256-5UsCBu3rtt+l2HZiCswoQJPPh8T6y471TBF4AypdF9I=";
  };
in lldb_12.overrideAttrs (oldAttrs: {
  src = "${llvmSrc}/lldb";

  passthru = (oldAttrs.passthru or {}) // {
    inherit llvmSrc;
  };

  doInstallCheck = true;
  postInstallCheck = (oldAttrs.postInstallCheck or "") + ''
    versionOutput="$($out/bin/lldb --version)"
    echo "'lldb --version' returns: $versionOutput"
    echo "$versionOutput" | grep -q 'rust-enabled'
  '';
})
