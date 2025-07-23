import { fetchDefaultWithTypes } from "./fetch-default.ts";

type Config = SingleFodFetcherConfig;
export async function fetchAllHttps(
  config: Config,
): Promise<CommonLockFormatOut> {
  let result: CommonLockFormatOut = [];
  const resultUnresolved = config.commonLockfileHttps.map((p)=>fetchDefaultWithTypes(config, p))

  await Promise.all(resultUnresolved).then((packageFiles) => {
    const a = packageFiles.flat();
    const b = a.map((v) => {
      if (v?.meta?.original) {
        v.url = v.meta.original.url;
      }
      return v;
    });
    result = result.concat(b);
  });
  return result;
}
