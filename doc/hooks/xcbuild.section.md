
### xcbuildHook {#xcbuildhook}

Overrides the build and install phases to run the "xcbuild" command. This hook is needed when a project only comes with build files for the XCode build system. You can disable this behavior by setting buildPhase and configurePhase to a custom value. xcbuildFlags controls flags passed only to xcbuild.
