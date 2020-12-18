/* SPDX-FileCopyrightText: 2020 Oliver Smith <ollieparanoid@postmarketos.org>
 * SPDX-License-Identifier: GPL-3.0-or-later */
#pragma once
#include "Job.h"


class UsersJob : public Calamares::Job
{
    Q_OBJECT
public:
    UsersJob( bool featureSshd,
              const QString& cmdPasswd,
              const QString& cmdSshd,
              const QString& cmdSshdUseradd,
              bool isSshEnabled,
              const QString& username,
              const QString& password,
              const QString& sshdUsername,
              const QString& sshdPassword );

    QString prettyName() const override;
    Calamares::JobResult exec() override;

    Calamares::JobList createJobs();

private:
    bool m_featureSshd;
    QString m_cmdPasswd;
    QString m_cmdSshd;
    QString m_cmdSshdUseradd;
    bool m_isSshEnabled;
    QString m_username;
    QString m_password;
    QString m_sshdUsername;
    QString m_sshdPassword;
};
