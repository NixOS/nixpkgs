/* SPDX-FileCopyrightText: 2020 Oliver Smith <ollieparanoid@postmarketos.org>
 * SPDX-License-Identifier: GPL-3.0-or-later */
#pragma once
#include "Job.h"


class UsersJob : public Calamares::Job
{
    Q_OBJECT
public:
    UsersJob( QString cmdPasswd, QString cmdSshd, QString cmdSshdUseradd,
              bool isSshEnabled,
              QString username, QString password,
              QString sshdUsername, QString sshdPassword );

    QString prettyName() const override;
    Calamares::JobResult exec() override;

    Calamares::JobList createJobs();

private:
    QString m_cmdPasswd;
    QString m_cmdSshd;
    QString m_cmdSshdUseradd;
    bool m_isSshEnabled;
    QString m_username;
    QString m_password;
    QString m_sshdUsername;
    QString m_sshdPassword;
};
