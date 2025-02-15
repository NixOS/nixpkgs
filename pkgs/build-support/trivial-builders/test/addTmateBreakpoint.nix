{ addTmateBreakpoint, hello }: (addTmateBreakpoint hello).overrideAttrs { postPatch = "exit 1"; }
