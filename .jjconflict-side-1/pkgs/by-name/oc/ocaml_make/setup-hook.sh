addOcamlMakefile () {
    export OCAMLMAKEFILE="@out@/include/OCamlMakefile"
}

addEnvHooks "$targetOffset" addOcamlMakefile
