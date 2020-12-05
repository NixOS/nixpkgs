/* SPDX-FileCopyrightText: 2020 Oliver Smith <ollieparanoid@postmarketos.org>
 * SPDX-License-Identifier: GPL-3.0-or-later */
#pragma once
#include "Job.h"


class PartitionJob : public Calamares::Job
{
    Q_OBJECT
public:
    PartitionJob( QString cmdLuksFormat,
                  QString cmdLuksOpen,
                  QString cmdMkfsRoot,
                  QString cmdMount,
                  QString targetDeviceRoot,
                  bool isFdeEnabled,
                  const QString& password );

    QString prettyName() const override;
    Calamares::JobResult exec() override;

    Calamares::JobList createJobs();

private:
    QString m_cmdLuksFormat;
    QString m_cmdLuksOpen;
    QString m_cmdMkfsRoot;
    QString m_cmdMount;
    QString m_targetDeviceRoot;
    bool m_isFdeEnabled;
    QString m_password;
};
