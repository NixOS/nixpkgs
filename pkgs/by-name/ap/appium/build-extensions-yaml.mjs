import process from 'node:process'
import { readFileSync, realpathSync } from 'node:fs'
import { join, resolve } from 'node:path';

// Invoke with node build-extensions-yaml.mjs <drivers...>

function readExtension(path) {
    const resolvedPath = realpathSync(resolve(path))
    const manifest = JSON.parse(readFileSync(join(resolvedPath, "package.json")));
    return {
        path: resolvedPath,
        manifest
    }
}

const extensions = process.argv.slice(2).map(readExtension);

const extensionsManifest = {
    drivers: {},
    plugins: {},
    schemaRev: 4,
};

for (const extension of extensions) {
    const { driverName, pluginName } = extension.manifest.appium
    if (!driverName && !pluginName) {
        throw new Error("No driver or plugin name was found")
    }
    if (driverName) {
        extensionsManifest.drivers[driverName] = {
            pkgName: extension.manifest.name,
            version: extension.manifest.version,
            installType: "local",
            installSpec: driverName,
            installPath: extension.path,
            appiumVersion: `${extension.manifest.peerDependencies.appium}`,
            ...extension.manifest.appium,
            driverName: undefined,
        }
    }

    if (pluginName) {
        extensionsManifest.plugins[pluginName] = {
            pkgName: extension.manifest.name,
            version: extension.manifest.version,
            installType: "local",
            installSpec: pluginName,
            installPath: extension.path,
            appiumVersion: `${extension.manifest.peerDependencies.appium}`,
            ...extension.manifest.appium,
        }
    }
}

console.log(JSON.stringify(extensionsManifest))
