// eslint-disable-next-line @typescript-eslint/no-var-requires
require("dotenv").config();

import { AutoUnpackNativesPlugin } from "@electron-forge/plugin-auto-unpack-natives";
import { FusesPlugin } from "@electron-forge/plugin-fuses";
import { WebpackPlugin } from "@electron-forge/plugin-webpack";
import type { ForgeConfig } from "@electron-forge/shared-types";
import { getAppTransportSecuity, getExtraResource, getIco, getIcon, getName, isBetaRelease } from "./src/utils/config";

import { FuseV1Options, FuseVersion } from "@electron/fuses";
import { mainConfig } from "./webpack.main.config";
import { rendererConfig } from "./webpack.renderer.config";
import pkg from "./package.json";

let currentArch = "";
const config: ForgeConfig = {
    hooks: {
        generateAssets: async (_x, _y, arch) => {
            if (arch === "all") {
                currentArch = "universal";
                return;
            }
            currentArch = arch;
        },
    },
    packagerConfig: {
        electronZipDir: process.env.electron_zip_dir,
        icon: `${__dirname}/assets/icons/${getIcon()}`,
        asar: true,
        name: getName(),
        executableName: getName(),
        extraResource: getExtraResource(),
        appVersion: pkg.version,
        appCopyright: pkg.config.copyright,
        // Required for macOS mailto protocol
        protocols: [
            {
                name: "mailto",
                schemes: ["mailto"],
            },
        ],
        // Change category type of the application on macOS
        appCategoryType: "public.app-category.productivity",
        appBundleId: pkg.config.appBundleId,
        osxSign: {},
        osxNotarize: {
            appleId: process.env.APPLE_ID!,
            appleIdPassword: process.env.APPLE_PASSWORD!,
            teamId: process.env.APPLE_TEAM_ID!,
        },
        extendInfo: {
            ...getAppTransportSecuity(),
        },
    },
    rebuildConfig: {},
    makers: [
        {
            name: "@electron-forge/maker-squirrel",
            config: {
                name: "proton_mail", // Avoids clash with ProtonMail folder used by Bridge in appData
                iconUrl: `${__dirname}/assets/icons/${getIco()}`,
                setupIcon: `${__dirname}/assets/icons/${getIco()}`,
                loadingGif: `${__dirname}/assets/windows/install-spinner.gif`,
                signWithParams: `/a /d "Proton Mail Desktop" /t "http://timestamp.sectigo.com" /fd SHA256`,
            },
        },
        {
            name: "@electron-forge/maker-dmg",
            config: {
                background: `${__dirname}/assets/macos/background.png`,
                icon: `${__dirname}/assets/macos/volume.icns`,
                contents: () => {
                    return [
                        {
                            x: 229,
                            y: 250,
                            type: "file",
                            path: `${process.cwd()}/out/${getName()}-darwin-${currentArch}/${getName()}.app`,
                        },
                        { x: 429, y: 250, type: "link", path: "/Applications" },
                    ];
                },
                additionalDMGOptions: {
                    window: {
                        size: {
                            width: 658,
                            height: 490,
                        },
                    },
                },
            },
        },
        {
            name: "@electron-forge/maker-rpm",
            config: {
                options: {
                    bin: getName(),
                    icon: `${__dirname}/assets/linux/${getIcon()}.svg`,
                    homepage: pkg.author.url,
                    categories: ["Network", "Email"],
                    mimeType: ["x-scheme-handler/mailto"],
                },
            },
        },
        {
            name: "@electron-forge/maker-deb",
            config: {
                options: {
                    bin: getName(),
                    icon: `${__dirname}/assets/linux/${getIcon()}.svg`,
                    maintainer: pkg.author.name,
                    homepage: pkg.author.url,
                    categories: ["Network", "Email"],
                    mimeType: ["x-scheme-handler/mailto"],
                },
            },
        },
        {
            name: "@electron-forge/maker-zip",
            platforms: ["win32", "darwin", "linux"],
            config: {},
        },
    ],
    publishers: [
        {
            name: "@electron-forge/publisher-github",
            config: {
                prerelase: isBetaRelease,
                repository: {
                    owner: pkg.config.githubUser,
                    name: pkg.config.githubRepo,
                },
            },
        },
    ],
    plugins: [
        new AutoUnpackNativesPlugin({}),
        new WebpackPlugin({
            mainConfig,
            renderer: {
                config: rendererConfig,
                entryPoints: [
                    {
                        html: "./src/index.html",
                        js: "./src/renderer.ts",
                        name: "main_window",
                        preload: {
                            js: "./src/preload.ts",
                        },
                    },
                ],
            },
        }),
        new FusesPlugin({
            version: FuseVersion.V1,
            // Disables ELECTRON_RUN_AS_NODE
            [FuseV1Options.RunAsNode]: false,
            // Disables the NODE_OPTIONS environment variable
            [FuseV1Options.EnableNodeOptionsEnvironmentVariable]: false,
            // Disables the --inspect and --inspect-brk family of CLI options
            [FuseV1Options.EnableNodeCliInspectArguments]: false,
            // Enables validation of the app.asar archive on macOS
            [FuseV1Options.EnableEmbeddedAsarIntegrityValidation]: true,
            // Enforces that Electron will only load your app from "app.asar" instead of its normal search paths
            [FuseV1Options.OnlyLoadAppFromAsar]: true,
        }),
    ],
};

export default config;
