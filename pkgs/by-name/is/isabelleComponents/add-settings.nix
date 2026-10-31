{ writeTextFile }:

package: fnText:

package.overrideAttrs (
  finalAttrs: prevAttrs: {
    passthru.settings = writeTextFile {
      name = "${finalAttrs.pname or finalAttrs.name}-settings";
      text = fnText finalAttrs;
      destination = "/etc/settings";
    };
  }
)
