{ python3Packages }:

(python3Packages.toPythonApplication python3Packages.slothy).overrideAttrs (old: {
  __structuredAttrs = true;
  meta = old.meta // {
    mainProgram = "slothy-cli";
  };
})
