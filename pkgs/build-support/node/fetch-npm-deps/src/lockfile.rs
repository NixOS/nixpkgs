use std::collections::HashMap;

use serde::{Deserialize, Serialize};
use serde_json::Value;

#[derive(Debug, PartialEq)]
pub enum NpmLockfile {
    V1(NpmLockfileV1),
    V2(NpmLockfileV2),
    V3(NpmLockfileV3),
}

impl<'de> Deserialize<'de> for NpmLockfile {
    fn deserialize<D>(deserializer: D) -> Result<Self, D::Error>
    where
        D: serde::Deserializer<'de>,
    {
        use serde::de::Error;

        let value = Value::deserialize(deserializer)?;
        let lockfile_version_field = value
            .get("lockfileVersion")
            .ok_or_else(|| Error::missing_field("lockfileVersion"))?;
        let lockfile = match lockfile_version_field
            .as_i64()
            .ok_or_else(|| Error::custom("lockfileVersion is a not valid integer"))?
        {
            1 => NpmLockfile::V1(NpmLockfileV1::deserialize(value).map_err(|e| {
                Error::custom(format!("Couldn't deserialize lockfile version 1: {e}"))
            })?),
            2 => NpmLockfile::V2(NpmLockfileV2::deserialize(value).map_err(|e| {
                Error::custom(format!("Couldn't deserialize lockfile version 2: {e}"))
            })?),
            3 => NpmLockfile::V3(NpmLockfileV3::deserialize(value).map_err(|e| {
                Error::custom(format!("Couldn't deserialize lockfile version 3: {e}"))
            })?),
            _ => {
                return Err(Error::custom(
                    "Unsupported lockfile version. Please open an issue!",
                ))
            }
        };
        Ok(lockfile)
    }
}

impl Serialize for NpmLockfile {
    fn serialize<S>(&self, serializer: S) -> Result<S::Ok, S::Error>
    where
        S: serde::Serializer,
    {
        // only used for serialization, we cannot use NpmLockfile here because of recursion
        #[derive(Serialize)]
        #[serde(untagged)]
        enum SerializedNpmLockfile<'a> {
            V1(&'a NpmLockfileV1),
            V2(&'a NpmLockfileV2),
            V3(&'a NpmLockfileV3),
        }
        #[derive(Serialize)]
        #[serde(rename_all = "camelCase")]
        struct VersionedLockfile<'a> {
            lockfile_version: i64,
            #[serde(flatten)]
            lockfile: SerializedNpmLockfile<'a>,
        }

        let lockfile_version = self.lockfile_version().into();
        let versioned_lockfile = VersionedLockfile {
            lockfile_version,
            lockfile: match self {
                NpmLockfile::V1(lock) => SerializedNpmLockfile::V1(lock),
                NpmLockfile::V2(lock) => SerializedNpmLockfile::V2(lock),
                NpmLockfile::V3(lock) => SerializedNpmLockfile::V3(lock),
            },
        };
        versioned_lockfile.serialize(serializer)
    }
}

impl NpmLockfile {
    pub fn lockfile_version(&self) -> i32 {
        match self {
            NpmLockfile::V1(_) => 1,
            NpmLockfile::V2(_) => 2,
            NpmLockfile::V3(_) => 3,
        }
    }
}

#[derive(Debug, Serialize, Deserialize, PartialEq)]
pub struct NpmLockfileV1 {
    #[serde(default)]
    pub dependencies: HashMap<String, NpmDependency>,
    #[serde(flatten)]
    pub untyped: HashMap<String, Value>,
}

#[derive(Debug, Serialize, Deserialize, PartialEq, Default)]
pub struct NpmDependency {
    #[serde(default, skip_serializing_if = "Option::is_none")]
    pub version: Option<String>,
    #[serde(default, skip_serializing_if = "Option::is_none")]
    pub integrity: Option<String>,
    #[serde(default, skip_serializing_if = "Option::is_none")]
    pub resolved: Option<String>,
    #[serde(default, skip_serializing_if = "HashMap::is_empty")]
    pub dependencies: HashMap<String, NpmDependency>,
    #[serde(default)]
    pub bundled: bool,
    #[serde(flatten)]
    pub untyped: HashMap<String, Value>,
}

#[derive(Debug, Serialize, Deserialize, PartialEq)]
pub struct NpmLockfileV2 {
    #[serde(default, skip_serializing_if = "Option::is_none")]
    pub version: Option<String>,
    #[serde(default, skip_serializing_if = "HashMap::is_empty")]
    pub dependencies: HashMap<String, NpmDependency>,
    #[serde(skip_serializing_if = "HashMap::is_empty")]
    pub packages: HashMap<String, NpmPackage>,
    #[serde(flatten)]
    pub untyped: HashMap<String, Value>,
}

#[derive(Debug, Serialize, Deserialize, PartialEq, Default)]
pub struct NpmPackage {
    #[serde(default, skip_serializing_if = "Option::is_none")]
    pub name: Option<String>,
    #[serde(default, skip_serializing_if = "Option::is_none")]
    pub version: Option<String>,
    #[serde(default, skip_serializing_if = "Option::is_none")]
    pub resolved: Option<String>,
    #[serde(default, skip_serializing_if = "Option::is_none")]
    pub integrity: Option<String>,
    #[serde(flatten)]
    pub untyped: HashMap<String, Value>,
}

#[derive(Debug, Serialize, Deserialize, PartialEq)]
pub struct NpmLockfileV3 {
    pub name: String,
    #[serde(default, skip_serializing_if = "Option::is_none")]
    pub version: Option<String>,
    #[serde(default, skip_serializing_if = "HashMap::is_empty")]
    pub packages: HashMap<String, NpmPackage>,
    #[serde(flatten)]
    pub untyped: HashMap<String, Value>,
}
