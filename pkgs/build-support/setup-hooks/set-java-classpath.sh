# This setup hook adds every JAR in the share/java subdirectories of
# the build inputs to $CLASSPATH.

export CLASSPATH

addPkgToClassPath () {
    local jar
    for jar in $1/share/java/*.jar; do
        export CLASSPATH=''${CLASSPATH-}''${CLASSPATH:+:}''${jar}
    done
}

addEnvHooks "$targetOffset" addPkgToClassPath
