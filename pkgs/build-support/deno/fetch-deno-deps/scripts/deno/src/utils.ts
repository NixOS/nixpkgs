import { PackageSpecifier, PathString } from "./types.d.ts";

export function addPrefix(p: PathString, prefix: PathString): PathString {
  return prefix !== "" ? prefix + "/" + p : p;
}

export async function fileExists(path: string): Promise<boolean> {
  try {
    const stat = await Deno.stat(path);
    return stat.isFile;
  } catch (err) {
    if (err instanceof Deno.errors.NotFound) {
      return false;
    } else {
      throw err;
    }
  }
}

export function getScopedName(packageSpecifier: PackageSpecifier): string {
  const withScope = `@${packageSpecifier.scope}/${packageSpecifier.name}`;
  const withoutScope = packageSpecifier.name;
  return packageSpecifier.scope != null ? withScope : withoutScope;
}

export function getScopedNameVersion(
  packageSpecifier: PackageSpecifier,
): string {
  return `${getScopedName(packageSpecifier)}@${packageSpecifier.version}`;
}

export function getRegistryScopedNameVersion(
  packageSpecifier: PackageSpecifier,
): string {
  const withRegistry = `${packageSpecifier.registry}:${getScopedNameVersion(packageSpecifier)}`;
  const withoutRegistry = getScopedNameVersion(packageSpecifier);
  return packageSpecifier.registry != null ? withRegistry : withoutRegistry;
}

export function isPath(s: string): boolean {
  return s.startsWith("./") || s.startsWith("../") || s.startsWith("/");
}

export function getBasePath(path: PathString): PathString {
  return path.split("/").slice(0, -1).join("/");
}

export function getFileName(path: PathString): PathString {
  return path.split("/").slice(-1).join("/");
}

export function normalizeUnixPath(path: PathString): PathString {
  const segments = path.split("/");
  const stack = [];
  for (const segment of segments) {
    if (segment === "" || segment === ".") {
      continue;
    }
    if (segment === "..") {
      if (stack.length && stack[stack.length - 1] !== "..") {
        stack.pop();
      } else {
        stack.push("..");
      }
    } else {
      stack.push(segment);
    }
  }
  const isAbsolute = path.startsWith("/");
  return (isAbsolute ? "/" : "") + stack.join("/");
}
