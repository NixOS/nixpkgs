//! Minimum online evidence-retention policy. No purge is introduced here.
//! Append-only roles still cannot delete, even after this minimum expires.
use serde::Serialize;

// Conservative day bounds: any twelve calendar months <= 366 days,
// any three calendar months <= 92 days. These are local policy defaults,
// not a finding of PCI applicability or operational compliance.
pub const MIN_RETENTION_DAYS: u32 = 366;
pub const MIN_IMMEDIATE_DAYS: u32 = 92;

#[derive(Debug, Clone, Copy, Serialize, PartialEq, Eq)]
pub struct RetentionPolicy {
    retention_days: u32,
    immediate_access_days: u32,
}

impl Default for RetentionPolicy {
    fn default() -> Self {
        Self {
            retention_days: MIN_RETENTION_DAYS,
            immediate_access_days: MIN_IMMEDIATE_DAYS,
        }
    }
}

impl RetentionPolicy {
    pub fn from_settings(retention: Option<&str>, immediate: Option<&str>) -> Result<Self, String> {
        let retention_days = retention
            .map(str::parse::<u32>)
            .transpose()
            .map_err(|_| "invalid retention days")?
            .unwrap_or(MIN_RETENTION_DAYS);
        let immediate_access_days = immediate
            .map(str::parse::<u32>)
            .transpose()
            .map_err(|_| "invalid immediate-access days")?
            .unwrap_or(MIN_IMMEDIATE_DAYS);
        if retention_days < MIN_RETENTION_DAYS
            || immediate_access_days < MIN_IMMEDIATE_DAYS
            || immediate_access_days > retention_days
        {
            return Err(
                "retention must be >=366 days; immediate access >=92 and <=retention".into(),
            );
        }
        Ok(Self {
            retention_days,
            immediate_access_days,
        })
    }

    /// Uses the trusted store admission time, never a producer's claimed timestamp.
    /// Reaching this instant grants no deletion authority.
    pub fn minimum_hold_until(&self, admitted_at_unix: u64) -> Option<u64> {
        admitted_at_unix.checked_add(u64::from(self.retention_days) * 86_400)
    }
}

#[cfg(test)]
mod tests {
    use super::*;

    #[test]
    fn defaults_cover_twelve_and_three_calendar_months_conservatively() {
        let policy = RetentionPolicy::default();
        assert_eq!(policy.retention_days, 366);
        assert_eq!(policy.immediate_access_days, 92);
        assert_eq!(policy.minimum_hold_until(100), Some(100 + 366 * 86_400));
        assert_eq!(policy.minimum_hold_until(u64::MAX), None);
    }

    #[test]
    fn invalid_or_weaker_settings_fail_instead_of_silently_defaulting() {
        for settings in [
            (Some("365"), None),
            (Some("0"), None),
            (Some("invalid"), None),
            (None, Some("91")),
            (Some("366"), Some("367")),
        ] {
            assert!(RetentionPolicy::from_settings(settings.0, settings.1).is_err());
        }
        assert!(RetentionPolicy::from_settings(Some("730"), Some("180")).is_ok());
    }
}
