type TsTypesJson = Array<string>;
type LockfileTransformerConfig = {
  inPath: PathString;
  inPathTsTypes: PathString;
  outPathJsr: PathString;
  outPathNpm: PathString;
  outPathHttps: PathString;
  lockfile: DenoLock;
};

type FileTransformerNpmConfig = {
  inPath: PathString;
  inBasePath: PathString;
  cachePath: PathString;
  commonLockfile: CommonLockFormatOut;
  rootPath: PathString;
};

type SingleFodFetcherConfig = {
  outPathPrefix: PathString;
  inPathJsr: PathString;
  inPathNpm: PathString;
  inPathHttps: PathString;
  outPathVendored: PathString;
  outPathNpm: PathString;
  commonLockfileJsr: CommonLockFormatIn;
  commonLockfileNpm: CommonLockFormatIn;
  commonLockfileHttps: CommonLockFormatIn;
};

// ==============

type PackageSpecifier = {
  fullString: string;
  registry: string | null;
  scope: string | null;
  name: string;
  version: string;
  suffix: string | null;
};

type PathString = string;
type PackageSpecifierString = string;
type HashString = string;

type PackageFileIn = {
  url: UrlString;
  hash: HashString;
  hashAlgo: "sha256" | "sha512";
  meta?: any;
};

type PackageFileOut = {
  url: UrlString;
  hash: HashString;
  hashAlgo: "sha256" | "sha512";
  outPath: PathString;
  headers?: Record<string, string>;
  meta?: any;
};

type CommonLockFormatOut = Array<PackageFileOut>;

type CommonLockFormatIn = Array<PackageFileIn>;

// ==============

type Dependency =
  | {
      type: "static";
      kind: "importType" | "import" | "export";
      specifier: PathString | PackageSpecifierString;
      specifierRange: Array<Array<number>>;
      importAttributes: any;
    }
  | {
      type: "dynamic";
      argument: PathString | PackageSpecifierString | Array<{type:string, value:any}>;
      argumentRange: Array<Array<number>>;
    };

// Rough type modelling of the jsr `<version>_meta.json` file
type VersionMetaJson = {
  manifest: { [filePath: PathString]: { size: number; checksum: HashString } };
  moduleGraph2: {
    [filePath: PathString]: { dependencies?: Array<Dependency> };
  };
  moduleGraph1: {
    [filePath: PathString]: { dependencies?: Array<Dependency> };
  };
  exports: { [filePath: PathString]: PathString };
};

type MetaJson = {
  name: string;
  scope: string;
  latest: string;
  versions: { [version: string]: Record<PropertyKey, never> };
};

type RegistryJson = {
  name: string;
  "dist-tags": Record<PropertyKey, never>;
  "_deno.etag": string;
  versions: {
    [version: string]: {
      version: string;
      dist: {
        tarball: string;
      };
      bin: Record<PropertyKey, never>;
    };
  };
};

// ==============

type RegistryPackageSpecifierString = string;
type VersionString = string;
type UrlString = string;
type Sha512String = string;
type Sha256String = string;

type NpmPackages = {
  [p: PackageSpecifierString]: {
    integrity: Sha512String;
    os?: Array<string>;
    cpu?: Array<string>;
    dependencies: Array<PackageSpecifierString>;
    optionalDependencies: Array<PackageSpecifierString>;
    bin?: boolean;
    scripts?: boolean;
  };
};
type JsrPackages = {
  [p: PackageSpecifierString]: {
    integrity: Sha256String;
    dependencies: Array<PackageSpecifierString>;
  };
};
type HttpsPackages = {
  [url: UrlString]: Sha256String;
};
// Rough type modelling of the `deno.lock` file
type DenoLock = {
  specifiers: Record<RegistryPackageSpecifierString, VersionString>;
  version: "3" | "4" | "5";
  jsr: JsrPackages;
  npm: NpmPackages;
  redirects: {
    [p: UrlString]: UrlString;
  };
  remote: HttpsPackages;
  workspace: {
    dependencies: Array<RegistryPackageSpecifierString>;
  };
};
