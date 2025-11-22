export type PackageSpecifier = {
  fullString: string;
  registry: string | null;
  scope: string | null;
  name: string;
  version: string;
  suffix: string | null;
};

export type PathString = string;
export type PackageSpecifierString = string;
export type HashString = string;

export type PackageFileIn = Omit<PackageFileOut, "outPath" | "headers">;

export type HashAlgorithm = "sha256" | "sha512";
export type CryptoSubtleHashAlgo = "SHA-256" | "SHA-512";
export type HashEncoding = "hex" | "base64";
export type Hash = {
  string: HashString;
  algorithm: HashAlgorithm;
  encoding: HashEncoding;
}

export type PackageFileOut = {
  url: UrlString;
  hash: Hash;
  outPath: PathString;
  headers?: Record<string, string>;
  meta?: any;
};

export type CommonLockFormatOut = Array<PackageFileOut>;

export type CommonLockFormatIn = Array<PackageFileIn>;

// ==============

export type Dependency =
  | {
    type: "static";
    kind: "importType" | "import" | "export";
    specifier: PathString | PackageSpecifierString;
    specifierRange: Array<Array<number>>;
    importAttributes: any;
  }
  | {
    type: "dynamic";
    argument:
      | PathString
      | PackageSpecifierString
      | Array<{ type: string; value: any }>;
    argumentRange: Array<Array<number>>;
  };

// Rough type modelling of the jsr `<version>_meta.json` file
export type VersionMetaJson = {
  manifest: { [filePath: PathString]: { size: number; checksum: HashString } };
  moduleGraph2: {
    [filePath: PathString]: { dependencies?: Array<Dependency> };
  };
  moduleGraph1: {
    [filePath: PathString]: { dependencies?: Array<Dependency> };
  };
  exports: { [filePath: PathString]: PathString };
};

export type MetaJson = {
  name: string;
  scope: string;
  latest: string;
  versions: { [version: string]: Record<PropertyKey, never> };
};

export type RegistryJson = {
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

export type RegistryPackageSpecifierString = string;
export type VersionString = string;
export type UrlString = string;
export type Sha512String = string;
export type Sha256String = string;

export type NpmPackages = {
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
export type JsrPackages = {
  [p: PackageSpecifierString]: {
    integrity: Sha256String;
    dependencies: Array<PackageSpecifierString>;
  };
};
export type HttpsPackages = {
  [url: UrlString]: Sha256String;
};
// Rough type modelling of the `deno.lock` file
export type DenoLock = {
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

// ==============

export type ParsedArgsNames = Record<string, null>;
export type UnparsedArgs<T extends ParsedArgsNames> = {
  [key in keyof T]: UnparsedArg;
};
export type ParsedArgs<T extends ParsedArgsNames> = {
  [key in keyof T]: ParsedArg;
};
export type UnparsedArg = Omit<ParsedArg, "value">;
export type ParsedArg = { flag: string; defaultValue: string; value: string };
