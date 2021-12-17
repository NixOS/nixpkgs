# This setup hook adds every JAR in the share/java subdirectories of
# the build inputs to $CLASSPATH.

export CLASSPATH

addPkgToClassPath () {
    local jar
    shopt -u failglob
    shopt -s nullglob
    for jar in $1/share/java/*.jar; do
        export CLASSPATH=''${CLASSPATH-}''${CLASSPATH:+:}''${jar}
    done
    shopt -u nullglob
    shopt -s failglob
}

addEnvHooks "$targetOffset" addPkgToClassPath
