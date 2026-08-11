{
  lib,
  fetchzip,
  buildNpmPackage,
  versionCheckHook,
}:

buildNpmPackage (finalAttrs: {
  pname = "bob-shell";
  version = "1.0.4";
  __structuredAttrs = true;

  src = fetchzip {
    url = "https://s3.us-south.cloud-object-storage.appdomain.cloud/bob-shell/bobshell-1.0.4.tgz";
    hash = "sha256-7oWbx7MJbnm4ieb/oems18XiYg0hfAf1G9VReLKpnNs=";
  };

  postPatch = ''
    cp ${./package-lock.json} package-lock.json
  '';
  npmDepsHash = "sha256-iHo7rhMn0R7yvgh2LXUF5o7rslds7CZLQH8xPgpV/Q8=";

  dontNpmBuild = true;

  doInstallCheck = true;
  nativeInstallCheckInputs = [ versionCheckHook ];

  meta = {
    description = "Agentic coding tool for terminal-driven development workflows";
    longDescription = ''
      IBM Bob is an AI SDLC (Software Development Lifecycle) partner that augments
      your existing workflows and helps you work confidently with real codebases.
    '';
    homepage = "https://bob.ibm.com/docs/shell";
    downloadPage = "https://bob.ibm.com/download?bob=shell";
    changelog = "https://bob.ibm.com/docs/shell/changelog";
    license = lib.licenses.unfree;
    maintainers = with lib.maintainers; [
      mpatankar6
    ];
    mainProgram = "bob";
  };
})
